nextflow.enable.dsl=2

params.email = 'adrian.navarro@outlook.com'

process someTask {
  secret 'FOO'
  secret 'BAR'
  secret 'testsecret'
  output: 
     stdout 
  script:
  '''
    echo "Secrets phrase: $FOO $BAR $testsecret"
  '''
}

workflow {
  someTask().view()
}


workflow.onComplete {
    def msg = """\
        Pipeline execution summary
        ---------------------------
        Completed at: ${workflow.complete}
        Duration    : ${workflow.duration}
        Success     : ${workflow.success}
        workDir     : ${workflow.workDir}
        exit status : ${workflow.exitStatus}
        """
        .stripIndent()

    sendMail(to: params.email, from: params.email, subject: 'My pipeline execution', body: msg)
}
