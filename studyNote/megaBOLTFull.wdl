version 1.0

task megaBOLTFull{
    input {
        String MegaBOLTFULL_shell_py
        String sampleid
        String megaBOLTFull
        String type
        String? bed
        String outdir
        String href 
        String hdbsnp
        String? scalafile
        Int? nobamoutput
        Int? extractdepth
        String? erc 
        Int? stand_call_conf
        Int? interval_padding
        Int cpp
        Int mem
        String sgequeueid
        String sgeprojectid
        String presuccess
        Int runcode
    }
    
    command<<<  
        
        if [ ${runcode} -gt 0 ]
        then
            echo "full  start [ `date +%F` `date +%T` ]" >${outdir}/runtime/full.time
            echo "${megaBOLTFull} ${outdir}/temp/sample.list \\
                --type ${type} \\
                --outdir ${outdir} \\
                --nobamoutput ${default=0 nobamoutput} \\
                --extractdepth ${default=0 extractdepth} \\
                --ERC ${default="NONE" erc} \\
                --stand_call_conf ${default=30 stand_call_conf} \\
                --interval_padding ${default=100 interval_padding} \\">${outdir}/temp/temp_full.sh
                
            python ${MegaBOLTFULL_shell_py} -r ${href} -v ${hdbsnp} -t ${type} -b ${default="NONE" bed} -s ${default="NONE" scalafile} -i ${outdir}/temp/temp_full.sh -o ${outdir}/temp/full.sh
            
            sh ${outdir}/temp/full.sh >${outdir}/logs/full.o 2>${outdir}/logs/full.e
            echo $?         
            echo "full finish [ `date +%F` `date +%T` ]" >>${outdir}/runtime/full.time
            
            echo "modifiedresult modifiedresult0 start [ `date +%F` `date +%T` ]" >${outdir}/runtime/modifiedresult0.time
            
        else
            perl -we 'print STDERR "not run full again\n";'
            echo $?
        fi
        QsubType=1
        Script="full"
    >>>
    runtime{
        backend:"SGE"
        cpu:cpp
        memory:"${mem} GB"
        sge_queue:sgequeueid
        sge_project:sgeprojectid
        jobs_name:"full"
    }
    output{
        String success="done"
        Int rc=read_lines(stdout())[0]
    }
}

workflow main {
    call megaBOLTFull
}