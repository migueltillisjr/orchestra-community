## Process

1. Leverage the final refinement artifacts from `/orchestra/home/{USER_NAME}/website/03_refine_site/output/` as the deployment-stage working input.
2. If there are no files to leverage from `/orchestra/home/{USER_NAME}/website/03_refine_site/output/`, leverage all files from `/orchestra/home/{USER_NAME}/website/01_generate_site/output/` into `/orchestra/home/{USER_NAME}/website/04_deploy_site/output/`, then continue.
3. If there are still no files to leverage from `/orchestra/home/{USER_NAME}/website/01_generate_site/output/`, tell the user to generate a design and try again.
4. Run `chmod +x /orchestra/home/{USER_NAME}/website/04_deploy_site/references/deploy_cloudflare_worker.sh; /orchestra/home/{USER_NAME}/website/04_deploy_site/references/deploy_cloudflare_worker.sh /orchestra/home/{USER_NAME}/website/04_deploy_site/output/`