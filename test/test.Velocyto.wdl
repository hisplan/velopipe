version 1.0

import "modules/Velocyto.wdl" as Velocyto

workflow Velocyto {

    input {
        File bam
        File gtf
        File barcodeWhitelist
    }

    call Velocyto.Velocyto {
        input:
            bam = bam,
            gtf = gtf,
            barcodeWhitelist = barcodeWhitelist
    }

}
