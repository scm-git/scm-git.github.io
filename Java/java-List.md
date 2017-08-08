# [王孝东的个人空间](https://scm-git.github.io/)
### Java List
* 判断list中某个元素出现的次数：`Collections.frequency(list, e)`
* 打乱list总的元素顺序：`Collections.shuffle(list)`
* List.subList: 该方法返回的是原list的一个视图，如果原list的元素变化，可能会引起该方法返回值的变化，如果需要不变的指，需要重新new一个List并装入subList返回的结果
