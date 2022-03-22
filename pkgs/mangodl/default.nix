{ buildGoModule, fetchFromGitHub, ... }: buildGoModule rec {
  pname = "mangodl-git";
  version = "1.5";
  src = fetchFromGitHub {
    owner = "Gyro7";
    repo = "mangodl";
    rev = "d4d20a8edd5e09f1ffc4d545e7fdd1ed1213d580";
    sha256 = "sha256-I9zZeqWW5VJ3+O9D6rhtPtc/mA0L8721oNhbMczVZqM=";
  };
  vendorSha256 = "sha256-txG1cTOjAIJbbO6wICN9kOXJLZZcIzC7B3t0LZhOgtE=";
  runVend = false;
}
