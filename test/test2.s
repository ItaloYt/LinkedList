.include "heap.S"
.include "linkedlist.S"

.global _start
.type _start, @function

.text
_start:
    bl heap_prepare

    bl linkedlist_create

    mov x19, x0

    mov x0, 0x1
    bl heap_allocate

    mov w1, 0x40
    strb w1, [x0]

    mov x20, x0

    mov x1, x0
    mov x0, x19
    bl linkedlist_push

    mov x0, 0x1
    bl heap_allocate

    mov w1, 0xf0
    strb w1, [x0]

    mov x21, x0

    mov x1, x0
    mov x0, x19
    bl linkedlist_push

    mov x0, 0x1
    bl heap_allocate

    mov w1, 0xff
    strb w1, [x0]

    mov x22, x0

    mov x1, x0
    mov x0, x19
    bl linkedlist_push

    mov x0, x19
    mov w1, 0x1
    bl linkedlist_get

    ldrb w1, [x0] // debug value

    mov x1, x0
    mov x0, x19
    bl linkedlist_removeValue

    mov x0, x19
    mov w1, 0x0
    bl linkedlist_get

    ldrb w1, [x0] // debug value

    mov x1, x0
    mov x0, x19
    bl linkedlist_find

    mov x0, x19
    bl linkedlist_free

    bl heap_free

    b _exit

_exit:
    mov x8, 0x5d
    mov x0, 0x0
    svc 0x0

.end
