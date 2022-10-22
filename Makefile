APPLICATION = grafana

REGISTRY ?= mireg.wr25.org
REPOGROUP ?=
KUBECTLOPTS ?=
RELEASE ?= latest
DOCKERCOMMAND ?= podman

.PHONY: clean

all: apply.touch

docker.digest: Dockerfile defaults.ini
	$(DOCKERCOMMAND) build -t $(REGISTRY)$(REPOGROUP)/$(APPLICATION):$(RELEASE) .
	$(DOCKERCOMMAND) push $(REGISTRY)$(REPOGROUP)/$(APPLICATION):$(RELEASE)

	echo -n "sha256:" > docker.digest 
	curl -s -H "Accept: application/vnd.docker.distribution.manifest.v2+json" https://$(REGISTRY)/v2$(REPOGROUP)/$(APPLICATION)/manifests/$(RELEASE) | sha256sum | awk '{print $$1}' >> docker.digest

deployment.apply.yml: docker.digest deployment.yml
	sed -i "s#image: [^/]*/$(APPLICATION):.*#image: $(REGISTRY)$(REPOGROUP)/$(APPLICATION):$(RELEASE)@$$(cat docker.digest)#" deployment.apply.yml

apply.touch: deployment.apply.yml
	kubectl $(KUBECTLOPTS) apply -f deployment.apply.yml
	kubectl $(KUBECTLOPTS) rollout status deployment $(APPLICATION)
	touch apply.touch

clean:
	rm $(APPLICATION) docker.digest apply.touch -f
