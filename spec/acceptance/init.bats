@test "downloaded OK" {
  ls /var/cache/download_and_do/download/coolapp.tar.gz
}

@test "installed OK" {
  grep "installed" /opt/coolapp/status.txt
}
