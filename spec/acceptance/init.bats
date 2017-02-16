@test "downloaded OK" {
  ls /var/cache/download_and_do/download/FOOBAR.tar
}

@test "installed OK" {
  grep "installed" /opt/patrol/status.txt
}
