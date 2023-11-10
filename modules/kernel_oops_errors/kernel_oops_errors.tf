resource "shoreline_notebook" "kernel_oops_errors" {
  name       = "kernel_oops_errors"
  data       = file("${path.module}/data/kernel_oops_errors.json")
  depends_on = [shoreline_action.invoke_cpu_stability_test,shoreline_action.invoke_update_kernel]
}

resource "shoreline_file" "cpu_stability_test" {
  name             = "cpu_stability_test"
  input_file       = "${path.module}/data/cpu_stability_test.sh"
  md5              = filemd5("${path.module}/data/cpu_stability_test.sh")
  description      = "Overclocking: Overclocking the CPU or other components can cause instability in the system, leading to Kernel Oops errors."
  destination_path = "/tmp/cpu_stability_test.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "update_kernel" {
  name             = "update_kernel"
  input_file       = "${path.module}/data/update_kernel.sh"
  md5              = filemd5("${path.module}/data/update_kernel.sh")
  description      = "Upgrade or patch the kernel to the latest version. This can help address any known bugs or issues that were fixed in the newer version."
  destination_path = "/tmp/update_kernel.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_cpu_stability_test" {
  name        = "invoke_cpu_stability_test"
  description = "Overclocking: Overclocking the CPU or other components can cause instability in the system, leading to Kernel Oops errors."
  command     = "`chmod +x /tmp/cpu_stability_test.sh && /tmp/cpu_stability_test.sh`"
  params      = ["STABILITY_TEST_TIMEOUT","MAX_TEMPERATURE","NUM_CPU_CORES"]
  file_deps   = ["cpu_stability_test"]
  enabled     = true
  depends_on  = [shoreline_file.cpu_stability_test]
}

resource "shoreline_action" "invoke_update_kernel" {
  name        = "invoke_update_kernel"
  description = "Upgrade or patch the kernel to the latest version. This can help address any known bugs or issues that were fixed in the newer version."
  command     = "`chmod +x /tmp/update_kernel.sh && /tmp/update_kernel.sh`"
  params      = ["VERSION_NUMBER"]
  file_deps   = ["update_kernel"]
  enabled     = true
  depends_on  = [shoreline_file.update_kernel]
}

