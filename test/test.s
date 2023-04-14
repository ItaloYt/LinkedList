.include "heap.S"
.include "linkedlist.S"

.global _start
.type _start, @function

.text
_start:
	bl heap_prepare

    mov x0, 0x1
    bl heap_allocate

    mov w9, 123
    strb w9, [x0]

    mov x21, x0 // value
    
    bl linkedlist_create

    mov x1, x21
    mov x19, x0
    bl linkedlist_push

    mov x0, 0x1
    bl heap_allocate

    mov w9, 99
    strb w9, [x0]

    mov x20, x0

    mov x1, x0
    mov x0, x19
    mov w2, 0x0
    bl linkedlist_insert

    mov x0, 0x1
    bl heap_allocate

    mov w9, 0xf
    strb w9, [x0]

    mov x1, x0
    mov x0, x19
    mov w2, 0x1
    bl linkedlist_insert
    
    mov x0, x19
    mov x1, 0x0
    bl linkedlist_get

    ldrb w0, [x0]

    mov x0, x19
    mov x1, 0x1
    bl linkedlist_get

    ldrb w0, [x0]

    mov x0, x19
    mov x1, 0x2
    bl linkedlist_get

    ldrb w0, [x0]

    // list size = 3
    mov x0, x19
    mov w1, 0x1
    bl linkedlist_remove

    // list size = 2
    mov x0, x19
    mov w1, 0x1
    bl linkedlist_remove

    // list size = 1
    mov x0, x19
    mov w1, 0x0
    bl linkedlist_remove

    mov x0, x19
    ldr x9, [x0]
    bl linkedlist_free

    bl heap_clear

	mov x8, 0x5d
	mov x0, 0x0
	svc 0x0

.end
