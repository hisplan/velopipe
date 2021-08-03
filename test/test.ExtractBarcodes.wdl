version 1.0

import "modules/ExtractBarcodes.wdl" as ExtractBarcodes

workflow ExtractBarcodes {

    input {
        File filteredBarcodes

        # docker-related
        String dockerRegistry        
    }

    call ExtractBarcodes.ExtractBarcodes {
        input:
            filteredBarcodes = filteredBarcodes,
            dockerRegistry = dockerRegistry
    }
}
