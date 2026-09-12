## Process

1. Copy the files from file location `website/03_refine_site/output/`  into `website/04_deploy_site/output/` as the final refinement working artifacts.
2. If there are no files to copy at file location `website/03_refine_site/output/`, copy all files from `website/01_generate_site/output/` into `website/04_deploy_site/output/` then continue
3. If there are still no files to copy from file location `website/01_generate_site/output/`, tell the user to generate a design and try again.
4. Run command `website/04_deploy_site/references/deploy_cloudflare_worker.sh website/04_deploy_site/output/` for deployment