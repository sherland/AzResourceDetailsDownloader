param sshPublicKeys_sshkey89_8y7sp_name string

resource sshPublicKeys_sshkey89_8y7sp_name_resource 'Microsoft.Compute/sshPublicKeys@2025-11-01' = {
  name: sshPublicKeys_sshkey89_8y7sp_name
  location: 'norwayeast'
  properties: {
    publicKey: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMf4Pa+FlecNaDqyuITzNaZErfcsxCCRt5SGvBMi7+xZc6A87B+uo4bdYyrKVS+pfdHXUtOkGn7IYj/UMqx8V2QVni32cUQa08zxj1d9Hv9yT2P+2apXNbEAfZ2gKtcFj4HgtXMR+gtCG5IOu16c8MsPytK52qgfYcw6L2AwhYCV3bNuEBW/cLEA8Kh9FmdCEkp0QWOXlwVq6XO7w01ORLtpZMx9+urnzq8s0uUcgSolVynmMTWeNMhJbQPu1iKygYU4dl+YSE+dKXqm863CQBvnpcmeRcIVHsCVBqV82mpF1mMGa0xqUA45Hu4FLuNVHJWYuJN5IuFwFBpjQDuRqH ardl@example.com'
  }
}

