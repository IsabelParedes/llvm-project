; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx2 | FileCheck %s

; FIXME: add (sext i1 X), 1 -> zext (not i1 X)

define i32 @sext_inc(i1 zeroext %x) nounwind {
; CHECK-LABEL: sext_inc:
; CHECK:       # BB#0:
; CHECK-NEXT:    movzbl %dil, %ecx
; CHECK-NEXT:    movl $1, %eax
; CHECK-NEXT:    subl %ecx, %eax
; CHECK-NEXT:    retq
  %ext = sext i1 %x to i32
  %add = add i32 %ext, 1
  ret i32 %add
}

; FIXME: add (sext i1 X), 1 -> zext (not i1 X)

define <4 x i32> @sext_inc_vec(<4 x i1> %x) nounwind {
; CHECK-LABEL: sext_inc_vec:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpslld $31, %xmm0, %xmm0
; CHECK-NEXT:    vpsrad $31, %xmm0, %xmm0
; CHECK-NEXT:    vpbroadcastd {{.*}}(%rip), %xmm1
; CHECK-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %ext = sext <4 x i1> %x to <4 x i32>
  %add = add <4 x i32> %ext, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %add
}

define <4 x i32> @cmpgt_sext_inc_vec(<4 x i32> %x, <4 x i32> %y) nounwind {
; CHECK-LABEL: cmpgt_sext_inc_vec:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcmpgtd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpbroadcastd {{.*}}(%rip), %xmm1
; CHECK-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %cmp = icmp sgt <4 x i32> %x, %y
  %ext = sext <4 x i1> %cmp to <4 x i32>
  %add = add <4 x i32> %ext, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %add
}

define <4 x i32> @cmpne_sext_inc_vec(<4 x i32> %x, <4 x i32> %y) nounwind {
; CHECK-LABEL: cmpne_sext_inc_vec:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpbroadcastd {{.*}}(%rip), %xmm1
; CHECK-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %cmp = icmp ne <4 x i32> %x, %y
  %ext = sext <4 x i1> %cmp to <4 x i32>
  %add = add <4 x i32> %ext, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %add
}

define <4 x i64> @cmpgt_sext_inc_vec256(<4 x i64> %x, <4 x i64> %y) nounwind {
; CHECK-LABEL: cmpgt_sext_inc_vec256:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcmpgtq %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    vpbroadcastq {{.*}}(%rip), %ymm1
; CHECK-NEXT:    vpaddq %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %cmp = icmp sgt <4 x i64> %x, %y
  %ext = sext <4 x i1> %cmp to <4 x i64>
  %add = add <4 x i64> %ext, <i64 1, i64 1, i64 1, i64 1>
  ret <4 x i64> %add
}

define i32 @bool_logic_and_math(i32 %a, i32 %b, i32 %c, i32 %d) nounwind {
; CHECK-LABEL: bool_logic_and_math:
; CHECK:       # BB#0:
; CHECK-NEXT:    cmpl %esi, %edi
; CHECK-NEXT:    setne %al
; CHECK-NEXT:    cmpl %ecx, %edx
; CHECK-NEXT:    setne %cl
; CHECK-NEXT:    andb %al, %cl
; CHECK-NEXT:    movzbl %cl, %eax
; CHECK-NEXT:    incl %eax
; CHECK-NEXT:    retq
  %cmp1 = icmp ne i32 %a, %b
  %cmp2 = icmp ne i32 %c, %d
  %and = and i1 %cmp1, %cmp2
  %zext = zext i1 %and to i32
  %add = add i32 %zext, 1
  ret i32 %add
}

define <4 x i32> @bool_logic_and_math_vec(<4 x i32> %a, <4 x i32> %b, <4 x i32> %c, <4 x i32> %d) nounwind {
; CHECK-LABEL: bool_logic_and_math_vec:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpcmpeqd %xmm3, %xmm2, %xmm2
; CHECK-NEXT:    vpxor %xmm1, %xmm2, %xmm1
; CHECK-NEXT:    vpandn %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpbroadcastd {{.*}}(%rip), %xmm1
; CHECK-NEXT:    vpsubd %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    retq
  %cmp1 = icmp ne <4 x i32> %a, %b
  %cmp2 = icmp ne <4 x i32> %c, %d
  %and = and <4 x i1> %cmp1, %cmp2
  %zext = zext <4 x i1> %and to <4 x i32>
  %add = add <4 x i32> %zext, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %add
}

