class apt_mirror::params (
  $base_path                 = '/var/spool/apt-mirror',
  $mirror_path               = '$base_path/mirror',
  $var_path                  = '$base_path/var',
  $defaultarch               = $::architecture,
  $cleanscript               = '$var_path/clean.sh',
  $postmirror_script         = '$var_path/postmirror.sh',
  $user                      = 'root',
  $group                     = 'root',
  $run_postmirror            = 0,
  $nthreads                  = 20,
  $tilde                     = 0,
) {

}
