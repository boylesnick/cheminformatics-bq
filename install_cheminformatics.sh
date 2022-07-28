#!/bin/bash 

## Create New Dataset to store the cheminformatics functions

bq mk --description "Dataset that will contain the cheminformatics functions" --dataset "cheminformatics" 

## Create Connection

bq mk --connection --display_name="Cheminformatics Connection" --connection_type=CLOUD_RESOURCE --location=US "cheminformatics-connection"

## Get Service Account associated to Connection

SERVICE_ACCOUNT=$(bq show --location=US --format=prettyjson --connection "cheminformatics-connection" | jq -r '.cloudResource.serviceAccountId')

echo "Connection created with service account: ${SERVICE_ACCOUNT}"

## Give service account the cloud run invoker role (necessary for cloud functions gen2)

PROJ=$(gcloud config list --format 'value(core.project)')

## Create Cloud functions 

PERM="roles/cloudfunctions.invoker"

## start installation by folder

cd rdkit 

## install rdkit-fingerprint

gcloud beta functions deploy rdkit-fingerprint --gen2 --region "us-east1" --entry-point rdkit_fingerprint --runtime python39 \
    --trigger-http --quiet --memory=512MB --timeout=120s --max-instances=100  > /dev/null

CLOUD_TRIGGER_URL=$(gcloud beta functions describe rdkit-fingerprint --gen2 --region "us-east1" --format=json | jq -r '.serviceConfig.uri')

gcloud beta functions add-iam-policy-binding "rdkit-fingerprint" --region "us-east1" --member=serviceAccount:${SERVICE_ACCOUNT} --role=${PERM} --gen2

gcloud run services add-iam-policy-binding "rdkit-fingerprint" --region "us-east1" --member=serviceAccount:${SERVICE_ACCOUNT} --role="roles/run.invoker"

bq query --use_legacy_sql=false --parameter="url::${CLOUD_TRIGGER_URL}" 'CREATE or REPLACE FUNCTION cheminformatics.rdkit_fingerprint(smiles STRING) RETURNS STRING REMOTE WITH CONNECTION `us.cheminformatics-connection` OPTIONS (endpoint = @url)'

## install rdkit-substructure-match

gcloud beta functions deploy rdkit-substructure-match --gen2 --region "us-east1" --entry-point rdkit_substructure_match --runtime python39 \
    --trigger-http --quiet --memory=512MB --timeout=120s --max-instances=100  > /dev/null

CLOUD_TRIGGER_URL=$(gcloud beta functions describe rdkit-substructure-match --gen2 --region "us-east1" --format=json | jq -r '.serviceConfig.uri')

gcloud beta functions add-iam-policy-binding "rdkit-substructure-match" --region "us-east1" --member=serviceAccount:${SERVICE_ACCOUNT} --role=${PERM} --gen2

gcloud run services add-iam-policy-binding "rdkit-substructure-match" --region "us-east1" --member=serviceAccount:${SERVICE_ACCOUNT} --role="roles/run.invoker"

bq query --use_legacy_sql=false --parameter="url::${CLOUD_TRIGGER_URL}" 'CREATE or REPLACE FUNCTION cheminformatics.rdkit_substructure_match(fragment_smiles STRING, smiles STRING) RETURNS BOOL REMOTE WITH CONNECTION `us.cheminformatics-connection` OPTIONS (endpoint = @url)'

## install rdkit-molecular-descriptors

gcloud beta functions deploy rdkit-molecular-descriptors --gen2 --region "us-east1" --entry-point rdkit_molecular_descriptors --runtime python39 \
    --trigger-http --quiet --memory=512MB --timeout=120s --max-instances=100  > /dev/null

CLOUD_TRIGGER_URL=$(gcloud beta functions describe rdkit-molecular-descriptors --gen2 --region "us-east1" --format=json | jq -r '.serviceConfig.uri')

gcloud beta functions add-iam-policy-binding "rdkit-molecular-descriptors" --region "us-east1" --member=serviceAccount:${SERVICE_ACCOUNT} --role=${PERM} --gen2

gcloud run services add-iam-policy-binding "rdkit-molecular-descriptors" --region "us-east1" --member=serviceAccount:${SERVICE_ACCOUNT} --role="roles/run.invoker"

bq query --use_legacy_sql=false --parameter="url::${CLOUD_TRIGGER_URL}" 'CREATE or REPLACE FUNCTION cheminformatics.rdkit_molecular_descriptors(smiles STRING) RETURNS STRING REMOTE WITH CONNECTION `us.cheminformatics-connection` OPTIONS (endpoint = @url)'

## install rdkit-draw-svg

gcloud beta functions deploy rdkit-draw-svg --gen2 --region "us-east1" --entry-point rdkit_draw_svg --runtime python39 \
    --trigger-http --quiet --memory=512MB --timeout=120s --max-instances=100  > /dev/null

CLOUD_TRIGGER_URL=$(gcloud beta functions describe rdkit-draw-svg --gen2 --region "us-east1" --format=json | jq -r '.serviceConfig.uri')

gcloud beta functions add-iam-policy-binding "rdkit-draw-svg" --region "us-east1" --member=serviceAccount:${SERVICE_ACCOUNT} --role=${PERM} --gen2

gcloud run services add-iam-policy-binding "rdkit-draw-svg" --region "us-east1" --member=serviceAccount:${SERVICE_ACCOUNT} --role="roles/run.invoker"

bq query --use_legacy_sql=false --parameter="url::${CLOUD_TRIGGER_URL}" 'CREATE or REPLACE FUNCTION cheminformatics.rdkit_draw_svg(smiles STRING) RETURNS STRING REMOTE WITH CONNECTION `us.cheminformatics-connection` OPTIONS (endpoint = @url)'

## install rdkit-smiles-to-inchi

gcloud beta functions deploy rdkit-smiles-to-inchi --gen2 --region "us-east1" --entry-point rdkit_smiles_to_inchi --runtime python39 \
    --trigger-http --quiet --memory=512MB --timeout=120s --max-instances=100  > /dev/null

CLOUD_TRIGGER_URL=$(gcloud beta functions describe rdkit-smiles-to-inchi --gen2 --region "us-east1" --format=json | jq -r '.serviceConfig.uri')

gcloud beta functions add-iam-policy-binding "rdkit-smiles-to-inchi" --region "us-east1" --member=serviceAccount:${SERVICE_ACCOUNT} --role=${PERM} --gen2

gcloud run services add-iam-policy-binding "rdkit-smiles-to-inchi" --region "us-east1" --member=serviceAccount:${SERVICE_ACCOUNT} --role="roles/run.invoker"

bq query --use_legacy_sql=false --parameter="url::${CLOUD_TRIGGER_URL}" 'CREATE or REPLACE FUNCTION cheminformatics.rdkit_smiles_to_inchi(smiles STRING) RETURNS STRING REMOTE WITH CONNECTION `us.cheminformatics-connection` OPTIONS (endpoint = @url)'

## install rdkit-qed

gcloud beta functions deploy rdkit-qed --gen2 --region "us-east1" --entry-point rdkit_qed --runtime python39 \
    --trigger-http --quiet --memory=512MB --timeout=120s --max-instances=100  > /dev/null

CLOUD_TRIGGER_URL=$(gcloud beta functions describe rdkit-qed --gen2 --region "us-east1" --format=json | jq -r '.serviceConfig.uri')

gcloud beta functions add-iam-policy-binding "rdkit-qed" --region "us-east1" --member=serviceAccount:${SERVICE_ACCOUNT} --role=${PERM} --gen2

gcloud run services add-iam-policy-binding "rdkit-qed" --region "us-east1" --member=serviceAccount:${SERVICE_ACCOUNT} --role="roles/run.invoker"

bq query --use_legacy_sql=false --parameter="url::${CLOUD_TRIGGER_URL}" 'CREATE or REPLACE FUNCTION cheminformatics.rdkit_qed(smiles STRING) RETURNS STRING REMOTE WITH CONNECTION `us.cheminformatics-connection` OPTIONS (endpoint = @url)'


## move into biopython folder

cd ../biopython/

## install biopython-sequence-complement

gcloud beta functions deploy biopython-sequence-complement --gen2 --region "us-east1" --entry-point biopython_sequence_complement --runtime python39 --trigger-http --quiet --memory=512MB --timeout=120s --max-instances=100 > /dev/null

CLOUD_TRIGGER_URL=$(gcloud beta functions describe biopython-sequence-complement --gen2 --region "us-east1" --format=json | jq -r '.serviceConfig.uri')

gcloud beta functions add-iam-policy-binding "biopython-sequence-complement" --gen2 --region "us-east1" --member=serviceAccount:${SERVICE_ACCOUNT} --role=${PERM} 

gcloud run services add-iam-policy-binding "biopython-sequence-complement" --region "us-east1" --member=serviceAccount:${SERVICE_ACCOUNT} --role="roles/run.invoker"

bq query --use_legacy_sql=false --parameter="url::${CLOUD_TRIGGER_URL}" 'CREATE FUNCTION cheminformatics.biopython_sequence_complement(sequence STRING) RETURNS STRING REMOTE WITH CONNECTION `us.cheminformatics-connection` OPTIONS (endpoint = @url)'

## install biopython-sequence-translate

gcloud beta functions deploy biopython-sequence-translate --gen2 --region "us-east1" --entry-point biopython_sequence_translate --runtime python39 --trigger-http --quiet --memory=512MB --timeout=120s --max-instances=9000 > /dev/null

CLOUD_TRIGGER_URL=$(gcloud beta functions describe biopython-sequence-translate --gen2 --region "us-east1" --format=json | jq -r '.serviceConfig.uri')

gcloud beta functions add-iam-policy-binding "biopython-sequence-translate" --gen2 --region "us-east1" --member=serviceAccount:${SERVICE_ACCOUNT} --role=${PERM} 

gcloud run services add-iam-policy-binding "biopython-sequence-translate" --region "us-east1" --member=serviceAccount:${SERVICE_ACCOUNT} --role="roles/run.invoker"

bq query --use_legacy_sql=false --parameter="url::${CLOUD_TRIGGER_URL}" 'CREATE FUNCTION cheminformatics.biopython_sequence_translate(sequence STRING) RETURNS STRING REMOTE WITH CONNECTION `us.cheminformatics-connection` OPTIONS (endpoint = @url)'

## install biopython-sequence-translate-to-stop

gcloud beta functions deploy biopython-sequence-translate-to-stop --gen2 --region "us-east1" --entry-point biopython_sequence_translate_to_stop --runtime python39 --trigger-http --quiet --memory=512MB --timeout=120s --max-instances=9000 > /dev/null

CLOUD_TRIGGER_URL=$(gcloud beta functions describe biopython-sequence-translate-to-stop --gen2 --region "us-east1" --format=json | jq -r '.serviceConfig.uri')

gcloud beta functions add-iam-policy-binding "biopython-sequence-translate-to-stop" --gen2 --region "us-east1" --member=serviceAccount:${SERVICE_ACCOUNT} --role=${PERM} 

gcloud run services add-iam-policy-binding "biopython-sequence-translate-to-stop" --region "us-east1" --member=serviceAccount:${SERVICE_ACCOUNT} --role="roles/run.invoker"

bq query --use_legacy_sql=false --parameter="url::${CLOUD_TRIGGER_URL}" 'CREATE FUNCTION cheminformatics.biopython_sequence_translate_to_stop(sequence STRING) RETURNS STRING REMOTE WITH CONNECTION `us.cheminformatics-connection` OPTIONS (endpoint = @url)'

cd ..


## wait one minute for permissions to propagate
echo "Waiting for permissions to propagate ..."
sleep 90

