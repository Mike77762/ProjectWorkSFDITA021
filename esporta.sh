#!/bin/bash

echo "==================================================="
echo "Recupero del pacchetto dalla Dev Org (Mio)..."
echo "==================================================="
sf project retrieve start --package-name "MioProgetto" --target-org Mio

echo ""
echo "==================================================="
echo "Deploy dei metadati verso la Scratch Org (Scratch4)..."
echo "==================================================="
sf project deploy start --target-org Scratch4

echo ""
echo "==================================================="
echo "Operazione completata!"
echo "==================================================="