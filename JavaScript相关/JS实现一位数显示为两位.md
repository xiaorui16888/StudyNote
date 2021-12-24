# JS实现一位数显示为两位

使用js脚本实现页面一位数字显示为两位，不足两位前面加“0”。

```javascript
function fix(num, length) {
  return ('' + num).length < length ? ((new Array(length + 1)).join('0') + num).slice(-length) : '' + num;
}

fix(1234, 8);
// "00001234"
fix(1234, 2);
// "1234"
```