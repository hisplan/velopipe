version 1.0

import "modules/Velocyto.wdl" as Velocyto

workflow Velocyto {

    input {
        File bamCBSorted
        File bamPosSorted
        File baiPosSorted
        File gtf
        File filteredBarcodeSet

        # docker-related
        String dockerRegistry
    }

    call Velocyto.Velocyto {
        input:
            bamCBSorted = bamCBSorted,
            bamPosSorted = bamPosSorted,
            baiPosSorted = baiPosSorted,
            gtf = gtf,
            filteredBarcodeSet = filteredBarcodeSet,
            dockerRegistry = dockerRegistry
    }

}
