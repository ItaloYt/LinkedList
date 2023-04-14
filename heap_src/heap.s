.include "heap.S"

.global heap_prepare
.global heap_allocate
.global heap_free
.global heap_clear

.text

/*
	@description prepares heap for allocations
*/
heap_prepare:
	mov x8, 0xd6
	mov x0, 0x0
	svc 0x0

	mov x9, x0
	add x0, x0, 0x8
	svc 0x0

	str x9, [x0, -0x8]

	ret

/*
	@param w0, int size

	@return x0, void* ptr
	
	@description allocates <size> bytes in heap
*/
heap_allocate:
    mov w9, w0

	mov x8, 0xd6
	mov x0, 0x0
	svc 0x0

	ldr x10, [x0, -0x8]!

    mov x12, 0x0

    b .L1_allocate // searches for empty blocks

.L0_allocate:
    ldr x11, [x0]

    add x0, x0, 0xd // add x0, x0, 0x5
                    // add x0, x0, 0x8
	add x0, x0, x9
	svc 0x0

	str x11, [x0, -0x8]
	mov x0, x10

	mov w10, 0x1
	strb w10, [x0]
	str w9, [x0, 0x1]

	add x0, x0, 0x5

	ret

.L1_allocate:
    cmp x10, x0
    b.eq .L0_allocate // allocates more memory

    ldrb w11, [x10]
    cmp w11, 0x1

    ldr w11, [x10, 0x1]

    b.eq .L2_allocate // jumps to next block

    add w11, w12, w11

    cmp w11, w9
    sub x10, x10, x12
    b.hs .L3_allocate // uses current block

    add x10, x10, x12

    ldr w13, [x10, 0x1]
    
    add x10, x10, 0x5
    add x10, x10, x13

    add w12, w13, w12
    add w12, w12, 0x5

    b .L1_allocate

.L2_allocate:
    // ldr w11, [x10, 0x1]
    add x10, x10, 0x5
    add x10, x10, x11

    mov w12, 0x0

    b .L1_allocate

.L3_allocate:
    sub w11, w11, w9
    add w9, w9, w11
    cmp w11, 0x5

    adr x12, .
    add x12, x12, 0xc
    b.hi .L4_allocate // splits block into two

    mov w11, 0x1
    strb w11, [x10]
    str w9, [x10, 0x1]

    add x0, x10, 0x5

    ret

.L4_allocate:
    sub w9, w9, w11

    add x10, x10, 0x5
    add x10, x10, x9

    sub w11, w11, 0x5

    strb wzr, [x10]
    str w11, [x10, 0x1]

    sub x10, x10, 0x5
    sub x10, x10, x9

    br x12

/*
	@param x0, void* ptr

	@description frees <ptr>
*/
heap_free:
   strb wzr, [x0, -0x5]

   ret


/*
	@description clear heap
	* heap_prepare needs to be called to allocate in heap
	after this
*/
heap_clear:
	mov x8, 0xd6
	mov x0, 0x0
	svc 0x0

	ldr x0, [x0, -0x8]
	svc 0x0

	ret

.end
