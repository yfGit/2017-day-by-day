[Casa 基于ResponderChain的对象交互方式](https://casatwy.com/responder_chain_communication.html)

```
优

1. 以前靠delegate层层传递的方案，可以改为这种基于Responder Chain的方式来传递。在复杂UI层级的页面中，这种方式可以避免无谓的delegate声明。
2. 由于众多自定义事件都通过这种方式做了传递，就使得事件处理的逻辑得到归拢。在这个方法里面下断点就能够管理所有的事件处理。
3. 使用Strategy模式优化之后，UIViewController/UIView的事件响应逻辑得到了很好的管理，响应逻辑不会零散到各处地方。
4. 在此基础上使用Decorator模式，能够更加有序地收集、归拢数据，降低了工程的维护成本。
5. 无视命名域的存在
```


```
场景

1. 响应链

```


