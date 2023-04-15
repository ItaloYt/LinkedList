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

# Documentation
|---------|---------|
| test    |    1    |
