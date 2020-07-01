; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- -mattr=-sse2,+sse | FileCheck %s

; PR10497 + another isel issue with sse2 disabled
; (This is primarily checking that this construct doesn't crash.)
define void @a(<2 x float>* %a, <2 x i32>* %b) {
; CHECK-LABEL: a:
; CHECK:       # %bb.0:
; CHECK-NEXT:    subl $8, %esp
; CHECK-NEXT:    .cfi_def_cfa_offset 12
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    xorps %xmm0, %xmm0
; CHECK-NEXT:    movlps {{.*#+}} xmm0 = mem[0,1],xmm0[2,3]
; CHECK-NEXT:    addps %xmm0, %xmm0
; CHECK-NEXT:    movss %xmm0, {{[0-9]+}}(%esp)
; CHECK-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1,2,3]
; CHECK-NEXT:    movss %xmm0, (%esp)
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movl (%esp), %edx
; CHECK-NEXT:    addl %edx, %edx
; CHECK-NEXT:    addl %ecx, %ecx
; CHECK-NEXT:    movl %ecx, (%eax)
; CHECK-NEXT:    movl %edx, 4(%eax)
; CHECK-NEXT:    addl $8, %esp
; CHECK-NEXT:    .cfi_def_cfa_offset 4
; CHECK-NEXT:    retl
  %cc = load <2 x float>, <2 x float>* %a
  %c = fadd <2 x float> %cc, %cc
  %dd = bitcast <2 x float> %c to <2 x i32>
  %d = add <2 x i32> %dd, %dd
  store <2 x i32> %d, <2 x i32>* %b
  ret void
}