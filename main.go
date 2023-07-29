
package main

import (
	"log"

	stkv1alpha1 "gitlab.eng.vmware.com/services-control-plane/resource-claims/api/services/v1alpha1"
)

func main() {
  log.Printf("%#v", stkv1alpha1.ResourceClaim{})
  log.Print("ok")
}
