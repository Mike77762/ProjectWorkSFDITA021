#!/bin/bash

echo "==================================================="
echo "1. Creazione della Scratch Org 'ProjectWork'..."
echo "==================================================="
sf org create scratch --definition-file config/project-scratch-def.json --alias ProjectWork --set-default

echo ""
echo "==================================================="
echo "2. Deploy dei metadati verso la Scratch Org..."
echo "==================================================="
sf project deploy start --target-org ProjectWork --ignore-conflicts

echo ""
echo "==================================================="
echo "3. Assegnazione del Permission Set..."
echo "==================================================="
sf org assign permset --name ProjectWork --target-org ProjectWork

echo ""
echo "==================================================="
echo "4. Apertura della Org nel browser..."
echo "==================================================="
sf org open --target-org ProjectWork

echo "Setup completato con successo!"