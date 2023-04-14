.include "linkedlist.S"
.include "heap.S"

.global linkedlist_create
.global linkedlist_free
.global linkedlist_push
.global linkedlist_get
.global linkedlist_find
.global linkedlist_insert
.global linkedlist_remove
.global linkedlist_removeValue

/*
    struct LinkedList {
        void* first;
    };

    struct LinkedListElement {
        void* block
        void* next;
    };
*/

.text
/*
    @return x0, void* ptr

    @description allocated a linkedlist
*/
linkedlist_create:
    str x30, [sp, -0x10]!

    mov w0, 0x8 // linked list size
    bl heap_allocate

    str xzr, [x0]

    ldr x30, [sp], 0x10

    ret

/*
    @param x0, void* ptr
    @param x1, void* value

    @description adds a element to linkedlist
*/
linkedlist_push:
    ldr x9, [x0], -0x8

    b .L0_push // goes to last element

.L0_push:
    cbz x9, .L1_push // allocates new element

    mov x0, x9
    ldr x9, [x0, 0x8]

    b .L0_push

.L1_push:
    str x30, [sp, -0x20]! // saves current element ptr
    str x1, [sp, 0x8]
    str x0, [sp, 0x10]

    mov w0, 0x10 // linked list element size
    bl heap_allocate

    ldr x9, [sp, 0x10]
    str x0, [x9, 0x8]

    ldr x9, [sp, 0x8]
    str x9, [x0]
    str xzr, [x0, 0x8]

    ldr x30, [sp], 0x20

    ret

/*
    @param x0, void* ptr
    @param x1, void* value
    @param w2, int index

    @description inserts <value> at <index> in linked list <ptr>
*/
linkedlist_insert:
    mov w10, 0x0

    ldr x9, [x0], -0x8

    b .L0_insert // goes to <index>

.L0_insert:
    cbz x9, .L2_insert // index out of range

    cmp w10, w2
    b.eq .L1_insert // inserts

    mov x0, x9
    ldr x9, [x0, 0x8]

    add w10, w10, 0x1

    b .L0_insert

.L1_insert:
    str x30, [sp, -0x20]!
    str x0, [sp, 0x8]
    ldr x1, [sp, 0x10]
    
    mov x0, 0x10
    bl heap_allocate

    ldr x1, [sp, 0x10]
    str x1, [x0]

    mov x1, x0
    ldr x0, [sp, 0x8]
    ldr x2, [x0, 0x8]
    str x1, [x0, 0x8]
    str x2, [x1, 0x8]

    ldr x30, [sp], 0x20

    ret

.L2_insert: ret

/*
    @param x0, void* ptr
    @param w1, int index

    @description removes element at <index> from the linked list <ptr>
*/
linkedlist_remove:
    ldr x9, [x0], -0x8
    cbz x9, .L1_remove // index out of range

    mov w10, 0x0

    b .L0_remove // goes to <index>

.L0_remove:
    cmp w10, w1
    b.eq .L2_remove // remove element

    mov x0, x9
    ldr x9, [x0, 0x8]

    add w10, w10, 0x1

    b .L0_remove


.L1_remove: ret

.L2_remove:
    str x30, [sp, -0x10]!
    str x0, [sp, 0x8]

    mov x0, x9
    bl heap_free

    ldr x0, [sp, 0x8]
    ldr x9, [x0, 0x8]
    ldr x9, [x9, 0x8]
    str x9, [x0, 0x8]

    ldr x30, [sp], 0x10

    ret

/*
    @param x0, void* ptr
    @param x1, void* value

    @description removes a element by its value
*/
linkedlist_removeValue:
    str x30, [sp, -0x10]!
    str x0, [sp, 0x8]

    bl linkedlist_find

    mov w1, w0
    ldr x0, [sp, 0x8]
    bl linkedlist_remove

    ldr x30, [sp], 0x10

    ret

/*
    @param x0, void* ptr
    @param w1, int index

    @return x0, void* value

    @description gets the value at <index> in linked list <ptr>
*/
linkedlist_get:
    mov w10, 0x0
    ldr x9, [x0], -0x8

    b .L0_get // iterates in linked list

.L0_get:
    cbz x9, .L1_get // index out of range

    mov x0, x9
    ldr x9, [x0, 0x8]

    cmp w10, w1
    b.eq .L2_get // returns value at <index>
    
    add w10, w10, 0x1

    b .L0_get

.L1_get:
    mov x0, 0x0

    ret

.L2_get:
    ldr x0, [x0]

    ret

/*
    @param x0, void* ptr
    @param x1, void* value

    @return w0, int index

    @description finds a element index by its value
*/
linkedlist_find:
    mov w10, 0x0

    ldr x9, [x0], -0x8

    b .L0_find // searches for <value>

.L0_find:
    cbz x9, .L2_find // value not found

    ldr x11, [x9]
    cmp x11, x1
    b.eq .L1_find // return index

    mov x0, x9
    ldr x9, [x0, 0x8]

    add w10, w10, 0x1

    b .L0_find

.L1_find:
    mov w0, w10

    ret

.L2_find: ret

/*
    @param x0, void* ptr

    @description frees linked list and all its elements(doesn't include elements)
*/
linkedlist_free:
    str x30, [sp, -0x10]!
    str x0, [sp, 0x8]
    bl heap_free

    ldr x0, [sp, 0x8]
    ldr x0, [x0]
    cbz x0, .L1_free // returns

    ldr x9, [x0, 0x8]

    b .L0_free // loops through each element freeing it

.L0_free:
    str x9, [sp, 0x8]
    bl heap_free

    ldr x0, [sp, 0x8]
    cbz x0, .L1_free

    ldr x9, [x0, 0x8]

    b .L0_free

.L1_free:
    ldr x30, [sp], 0x10

    ret

.end
