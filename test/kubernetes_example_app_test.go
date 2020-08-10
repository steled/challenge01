// +build kubeall kubernetes
// NOTE: See the notes in the other Kubernetes example tests for why this build tag is included.

package test

import (
	"fmt"
	"testing"
	"time"
	"strings"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/k8s"
)

func TestKubernetesExampleApp(t *testing.T) {
	t.Parallel()

	// Here we choose to use the defaults, which is:
	// - HOME/.kube/config for the kubectl config file
	// - Current context of the kubectl config file
	// - Random namespace
	options := k8s.NewKubectlOptions("", "", "example-app")

	// Verify the service is available and get the URL for it.
	k8s.WaitUntilServiceAvailable(t, options, "example-app-service", 10, 1*time.Second)
	service := k8s.GetService(t, options, "example-app-service")
	url := fmt.Sprintf("http://%s/metrics", k8s.GetServiceEndpoint(t, options, service, 5001))

	// Make an HTTP request to the URL and make sure it returns a 200 OK and that the body contains "flask_exporter_info".
	http_helper.HttpGetWithRetryWithCustomValidation(
		t,
		url,
		nil,
		1,
		3*time.Second,
		func(statusCode int, body string) bool {
			return statusCode == 200 &&
				strings.Contains(body, "flask_exporter_info")
		},
	)
}