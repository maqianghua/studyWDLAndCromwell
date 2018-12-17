Scatter/Gather{
    Scatter用于并行处理一系列相同的任务，但输入略有不同.08.01.Scatter.wdl:运行此工作流(不需要输入)，将为wf.inc生成[2,3,4,5,6]的值。task inc本身返回一个Int，当它在Scatter中被调用时，该类型就变成一个Array[Int],即就是wf.inc.incremented是Array数组
    任何来自对inc调用的下游和Scatter之外的任务都必须接受Array[Int]：08.02.Scatter.wdl{
        这个工作流将为wf.sum.sum输出值20。这是因为call inc将输出一个Array[Int]，因为它位于散点块中。
    }
    2 但是，从Scatter范围内看，call inc的输出仍然是Int.08.03.Scatter.wdl:在这个例子中，inc和inc2被串行调用，其中一个的输出被馈送给另一个.inc2将输出Array[3,4,5,6,7]
}