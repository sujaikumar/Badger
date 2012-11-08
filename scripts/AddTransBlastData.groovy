package badger

import groovy.sql.Sql

def grailsApplication

getBlastData()
def getBlastData(){
	if (grailsApplication.config.t.blast.size()>0){
		for(item in grailsApplication.config.t.blast){
			item = item.toString()
     	 	def splitter = item.split("=",2)
     	 	println "Adding "+splitter[0]+" - "+splitter[1]
     	 	inFile = new File('data/'+splitter[1].trim()).text
     	 	addTransBlast(splitter[0].trim(),inFile)
     	 }
    }
}


//add Unigene annotations
def addTransBlast(db,blastFile){
    def annoMap = [:]
    def count_check = 0
    def count_all = 0
    annoMap.anno_db = db
    blastFile.eachLine { line ->		
        if ((matcher = line =~ /<Iteration_query-def>(.*?)<\/Iteration_query-def>/)){
                annoMap.contig_id = matcher[0][1]
                count_check = 0
        }                	
        if ((matcher = line =~ /<Hit_num>(.*?)<\/Hit_num>/)){
                count_check++
        }
        if ((matcher = line =~ /<Hit_id>(.*?)<\/Hit_id>/)){
                annoMap.anno_id = matcher[0][1]
        }
        if ((matcher = line =~ /<Hit_def>(.*?)<\/Hit_def>/)){
                annoMap.descr = matcher[0][1]
        }
        //get HSP info
        if ((matcher = line =~ /<Hsp_score>(.*?)<\/Hsp_score>/)){
                annoMap.score = matcher[0][1]
        }
        if ((matcher = line =~ /<Hsp_query-from>(.*?)<\/Hsp_query-from>/)){
                annoMap.anno_start = matcher[0][1]
        }
        if ((matcher = line =~ /<Hsp_query-to>(.*?)<\/Hsp_query-to>/)){
                annoMap.anno_stop = matcher[0][1]
        }
        if ((matcher = line =~ /<Hsp_hit-from>(.*?)<\/Hsp_hit-from>/)){
                annoMap.hit_start = matcher[0][1]
        }
        if ((matcher = line =~ /<Hsp_hit-to>(.*?)<\/Hsp_hit-to>/)){
                annoMap.hit_stop = matcher[0][1]
        }
        if ((matcher = line =~ /<Hsp_identity>(.*?)<\/Hsp_identity>/)){
                annoMap.identity = matcher[0][1]
        }
        if ((matcher = line =~ /<Hsp_gaps>(.*?)<\/Hsp_gaps>/)){
                annoMap.gaps = matcher[0][1]
        }
        if ((matcher = line =~ /<Hsp_align-len>(.*?)<\/Hsp_align-len>/)){
                annoMap.align = matcher[0][1]
        }
        if ((matcher = line =~ /<Hsp_qseq>(.*?)<\/Hsp_qseq>/)){
                annoMap.qseq = matcher[0][1]
        }
        if ((matcher = line =~ /<Hsp_hseq>(.*?)<\/Hsp_hseq>/)){
                annoMap.hseq = matcher[0][1]
        }
        if ((matcher = line =~ /<Hsp_midline>(.*?)<\/Hsp_midline>/)){
                annoMap.midline = matcher[0][1]
        }
        //if ((matcher = line =~ /<Hsp_evalue>(.*?)<\/Hsp_evalue>/)){
        //        annoMap.eval = matcher[0][1]
        //}
        //find an end of an HSP and save data
        if ((matcher = line =~ /<\/Hsp>/)){
            //only add set number of elements from each blast
            if (count_check < 10){
            	//check for max evalue
            	def scoreInt = annoMap.score as Integer
            	if (scoreInt >= 100){
            		count_all++
            		if ((count_all % 1000) ==  0){
            			println count_all
            			//println annoMap
            			new TransBlast(annoMap).save(flush:true)
            		}else{
            			new TransBlast(annoMap).save()
            		}
            	}
            }
        } 
    }
}
