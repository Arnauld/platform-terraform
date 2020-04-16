
Write-Output "$pwd"
Write-Output "=================================="
#docker run --rm -v "$pwd":/root/infrastructure -it trv/ansible /bin/bash
docker run --rm `
    -v C:\Users\x2023576\projects\platform-terraform:/tf `
    -v C:\Users\x2023576\.aws:/root/.aws `
    -it --name terraform `
    --entrypoint /bin/bash `
    hashicorp/terraform:full