#!/bin/bash
checkers=(
    alpha.core.BoolAssignment
    alpha.core.CastSize
    alpha.core.CastToStruct
    alpha.core.FixedAddr
    alpha.core.IdenticalExpr
    alpha.core.PointerArithm
    alpha.core.PointerSub
    alpha.core.SizeofPtr

    alpha.cplusplus.NewDeleteLeaks
    alpha.cplusplus.VirtualCall

    alpha.deadcode.IdempotentOperations
    alpha.deadcode.UnreachableCode

    alpha.security.ArrayBound
    alpha.security.ArrayBoundV2
    alpha.security.MallocOverflow
    alpha.security.ReturnPtrRange
    alpha.security.taint.TaintPropagation

    alpha.unix.Chroot
    alpha.unix.MallocWithAnnotations
    alpha.unix.PthreadLock
    alpha.unix.SimpleStream
    alpha.unix.Stream
    alpha.unix.cstring.BufferOverlap
    alpha.unix.cstring.NotNullTerminated
    alpha.unix.cstring.OutOfBounds

    debug.ConfigDumper
    debug.DumpCFG
    debug.DumpCallGraph
    debug.DumpCalls
    debug.DumpDominators
    debug.DumpLiveVars
    debug.DumpTraversal
    debug.ExprInspection
    debug.Stats
    debug.TaintTest

    #debug.ViewCFG
    #debug.ViewCallGraph
    #debug.ViewExplodedGraph

    security.FloatLoopCounter
    security.insecureAPI.rand
    security.insecureAPI.strcpy
)

args=(
    -analyze-headers
    -o "$PWD/report"
    --keep-going
    --use-c++=clang++
    --use-analyzer=clang
)

get_checkers()
{
    for checker in "${checkers[@]}"; do
        printf "  -enable-checker %s\n" "$checker"
    done
}

main()
{
    scan-build "${args[@]}" $(get_checkers) "$@"
}

main "$@"
