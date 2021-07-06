version 1.0

import "modules/ExtractBarcodes.wdl" as ExtractBarcodes

workflow ExtractBarcodes {

    input {
        File countsMatrix

        # docker-related
        String dockerRegistry        
    }

    call ExtractBarcodes.ExtractBarcodes {
        input:
            countsMatrix = countsMatrix,
            dockerRegistry = dockerRegistry
    }
}
