#!/bin/bash

PROJECT=troubleshoot-lab
oc new-project $PROJECT || oc project $PROJECT

echo "Applying all DO280 troubleshooting scenarios..."

for yaml in *.yaml; do
    echo "Applying $yaml"
    oc apply -f $yaml
done

echo "Done. All scenarios deployed in project $PROJECT."

echo -e "\nTo clean up:"
echo "  oc delete all --all -n $PROJECT"
echo "  oc delete limitrange mem-limit -n $PROJECT"