version 1.0

import "modules/ExtractBarcodes.wdl" as ExtractBarcodes

workflow ExtractBarcodes {

    input {
        File countsMatrix
    }

    call ExtractBarcodes.ExtractBarcodes {
        input:
            countsMatrix = countsMatrix
    }
}
