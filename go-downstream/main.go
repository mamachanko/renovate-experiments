package main

import (
	"log"

	"github.com/mamachanko/renovate-experiments/go-upstream/upstream"
	stkv1alpha1 "gitlab.eng.vmware.com/services-control-plane/resource-claims/api/services/v1alpha1"
	corev1 "k8s.io/api/core/v1"
)

func main() {
	log.Printf("%#v", upstream.Upstream{})
	log.Printf("%#v", stkv1alpha1.ResourceClaim{})
	log.Printf("%#v", corev1.Secret{})
	log.Print("ok")
}
