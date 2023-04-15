# How can I use it?
* you can link it using ld to your executable:
```
~ $ as main.s -o main.o -Iyour_include -Ilinkedlist_include -Iheap_include
~ $ ld main.o shared/linkedlist.o -o main
```

# I want to implement my own heap, is it possible?
* yes, it is! but you won't be able to use the shared/linkedlist.o while linking because it already defines the heap.

* all the labels necessary to heap are defined at "include/". Once you created your own heap, you can use it:
```
~ $ as your_heap.s -o your_heap.o -Iheap_include
~ $ as main.s -o main.o -Iyour_include -Ilinkedlist_include -Iheap_include
~ $ as linkedlist_src/linkedlist.s -o linkedlist_src/linkedlist.o -Iheap_include -Ilinkedlist_include
~ $ ls main.o heap.o linkedlist_srd/linkedlist.o -o main
```

* your heap needs to be according with the documentation below

# Are there any examples?
* yes, there are! the "test/" directory contains two tests with source code in assembly and the AArch64 executable

# Documentation
## Linked List
| label | x0 | x1 | x2 | return (x0) | description |
| - | - | - | - | - | - |
| create | | | | void* ptr | allocates a linked list in heap |
| free | void* list | | | | free the linked list <list> and its elements(doesn't free values) |
| push | void* list | void* value | | | adds a element with value <value> in the end of linked list <list> |
| insert | void* list | void* value | int index | | inserts a element with value <value> at <index> in the linked list <list> |
| remove | void* list | int index | | | removes the element at <index> in the linked list <list> |
| removeValue | void* list | void* value | | | removes the element with value <value> in the linked list <list> |
| get | void* list | int index | | void* value | returns the element(at <index>)'s value |
| find | void* list | void* value | | int index | returnd the element(with value <value>)'s index |

* all the linked list labels starts with the prefix "linkedlist_". Example: `linkedlist_create`

## Heap
| label | x0 | return (x0) | description |
| - | - | - | - |
| prepare | | | prepares heap for allocations |
| clear | | | deallocates all the heap at once |
| allocate | int size | void* ptr | allocates <size> bytes in heap and returns the pointer |
| free | void* ptr | | deallocates the pointer <ptr>

* all the heap labels starts with the prefix "heap_". Example: `heap_prepare`
