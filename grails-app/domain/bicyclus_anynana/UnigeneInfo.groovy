package bicyclus_anynana

class UnigeneInfo {
    String contig_id
    String sequence
    Float gc
    Float coverage
    int length
    static constraints = {
        contig_id(blank:false)
        sequence(blank:false)
        gc(blank:false)
        coverage(blank:false)
        length(blank:false)
    }
    static mapping = {
        sequence type: "text"
        contig_id index:'unigene_contig'
    }
}
