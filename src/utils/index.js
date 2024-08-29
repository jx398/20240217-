/**
 * @author chuzhixin 1204505056@qq.com （不想保留author可删除）
 * @description 格式化时间
 * @param time
 * @param cFormat
 * @returns {string|null}
 */
export function parseTime(time, cFormat) {
  if (arguments.length === 0) {
    return null
  }
  const format = cFormat || '{y}-{m}-{d} {h}:{i}:{s}'
  let date
  if (typeof time === 'object') {
    date = time
  } else {
    if (typeof time === 'string' && /^[0-9]+$/.test(time)) {
      time = parseInt(time)
    }
    if (typeof time === 'number' && time.toString().length === 10) {
      time = time * 1000
    }
    date = new Date(time)
  }
  const formatObj = {
    y: date.getFullYear(),
    m: date.getMonth() + 1,
    d: date.getDate(),
    h: date.getHours(),
    i: date.getMinutes(),
    s: date.getSeconds(),
    a: date.getDay(),
  }
  const time_str = format.replace(/{(y|m|d|h|i|s|a)+}/g, (result, key) => {
    let value = formatObj[key]
    if (key === 'a') {
      return ['日', '一', '二', '三', '四', '五', '六'][value]
    }
    if (result.length > 0 && value < 10) {
      value = '0' + value
    }
    return value || 0
  })
  return time_str
}

/**
 * @author chuzhixin 1204505056@qq.com （不想保留author可删除）
 * @description 格式化时间
 * @param time
 * @param option
 * @returns {string}
 */
export function formatTime(time, option) {
  if (('' + time).length === 10) {
    time = parseInt(time) * 1000
  } else {
    time = +time
  }
  const d = new Date(time)
  const now = Date.now()

  const diff = (now - d) / 1000

  if (diff < 30) {
    return '刚刚'
  } else if (diff < 3600) {
    // less 1 hour
    return Math.ceil(diff / 60) + '分钟前'
  } else if (diff < 3600 * 24) {
    return Math.ceil(diff / 3600) + '小时前'
  } else if (diff < 3600 * 24 * 2) {
    return '1天前'
  }
  if (option) {
    return parseTime(time, option)
  } else {
    return (
      d.getMonth() +
      1 +
      '月' +
      d.getDate() +
      '日' +
      d.getHours() +
      '时' +
      d.getMinutes() +
      '分'
    )
  }
}

/**
 * @author chuzhixin 1204505056@qq.com （不想保留author可删除）
 * @description 10位时间戳转换
 * @param time
 * @returns {string}
 */
export function tenBittoTimestamp(time) {
  if (!time || typeof time !== 'string') {
    return parseTime(Date.now())
  }
  const matches =
    /(\d{4}).*?(\d{1,2}).*?(\d{1,2}).*?(\d{1,2}).*?(\d{1,2}).*?/.exec(time)
  if (!matches) {
    return null
  }

  const year = parseInt(matches[1], 10)
  let month = parseInt(matches[2], 10)
  month = month >= 1 && month <= 12 ? month - 1 : 0
  let day = parseInt(matches[3], 10)
  day = day >= 1 && day <= 31 ? day : 1
  let hour = parseInt(matches[4], 10)
  hour = hour >= 0 && hour <= 23 ? hour : 0
  let minute = parseInt(matches[5], 10)
  minute = minute >= 0 && minute <= 59 ? minute : 0

  let second = matches[6] == undefined ? 0 : parseInt(matches[6], 10)
  second = second >= 0 && second <= 59 ? second : 0
  const universalTimeRelation = matches[7] == undefined ? 'Z' : matches[7]
  let offsetHour = parseInt(matches[8], 10)
  offsetHour = offsetHour >= 0 && offsetHour <= 23 ? offsetHour : 0
  let offsetMinute = matches[6] == undefined ? 0 : parseInt(matches[9], 10) || 0
  offsetMinute = offsetMinute >= 0 && offsetMinute <= 59 ? offsetMinute : 0

  if (universalTimeRelation === '-') {
    hour += offsetHour
    minute += offsetMinute
  } else if (universalTimeRelation === '+') {
    hour -= offsetHour
    minute -= offsetMinute
  }

  return new Date(Date.UTC(year, month, day, hour, minute, second))
}

/**
 * @param time1,time2
 * @description 计算时间间隔
 * @type 返回的格式
 */
export function thirteenBitTimestamp(time) {
  const date1 = new Date(time / 1)
  const y = date.getFullYear()
  let m = date.getMonth() + 1
  m = m < 10 ? '' + m : m
  let d = date.getDate()
  d = d < 10 ? '' + d : d
  let h = date.getHours()
  h = h < 10 ? '0' + h : h
  let minute = date.getMinutes()
  let second = date.getSeconds()
  minute = minute < 10 ? '0' + minute : minute
  second = second < 10 ? '0' + second : second
  return y + '年' + m + '月' + d + '日 ' + h + ':' + minute + ':' + second //组合
}

/**
 * @author chuzhixin 1204505056@qq.com （不想保留author可删除）
 * @description 13位时间戳转换
 * @param time
 * @returns {string}
 */
export function diffSubtract(time1, time2, type) {
  const date1 = tenBittoTimestamp(time1)
  const date2 = tenBittoTimestamp(time2)
  const diff = date2.getTime() - date1.getTime()
  let diffTime = diff / (24 * 60 * 60 * 1000)
  let _val = diffTime >= 1.25 ? '2.0' : diffTime > 0.5 ? '1.5' : '1.0'
  return _val //组合
}

/**
 * @author chuzhixin 1204505056@qq.com （不想保留author可删除）
 * @description 将url请求参数转为json格式
 * @param url
 * @returns {{}|any}
 */
export function paramObj(url) {
  const search = url.split('?')[1]
  if (!search) {
    return {}
  }
  return JSON.parse(
    '{"' +
      decodeURIComponent(search)
        .replace(/"/g, '\\"')
        .replace(/&/g, '","')
        .replace(/=/g, '":"')
        .replace(/\+/g, ' ') +
      '"}'
  )
}

/**
 * @author chuzhixin 1204505056@qq.com （不想保留author可删除）
 * @description 父子关系的数组转换成树形结构数据
 * @param data
 * @returns {*}
 */
export function translateDataToTree(data) {
  const parent = data.filter(
    (value) => value.parentId === 'undefined' || value.parentId == null
  )
  const children = data.filter(
    (value) => value.parentId !== 'undefined' && value.parentId != null
  )
  const translator = (parent, children) => {
    parent.forEach((parent) => {
      children.forEach((current, index) => {
        if (current.parentId === parent.id) {
          const temp = JSON.parse(JSON.stringify(children))
          temp.splice(index, 1)
          translator([current], temp)
          typeof parent.children !== 'undefined'
            ? parent.children.push(current)
            : (parent.children = [current])
        }
      })
    })
  }
  translator(parent, children)
  return parent
}

/**
 * @author chuzhixin 1204505056@qq.com （不想保留author可删除）
 * @description 树形结构数据转换成父子关系的数组
 * @param data
 * @returns {[]}
 */
export function translateTreeToData(data) {
  const result = []
  data.forEach((item) => {
    const loop = (data) => {
      result.push({
        id: data.id,
        name: data.name,
        parentId: data.parentId,
      })
      const child = data.children
      if (child) {
        for (let i = 0; i < child.length; i++) {
          loop(child[i])
        }
      }
    }
    loop(item)
  })
  return result
}

/**
 * @author chuzhixin 1204505056@qq.com （不想保留author可删除）
 * @description 获取随机id
 * @param length
 * @returns {string}
 */
export function uuid(length = 32) {
  const num = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'
  let str = ''
  for (let i = 0; i < length; i++) {
    str += num.charAt(Math.floor(Math.random() * num.length))
  }
  return str
}

/**
 * @author chuzhixin 1204505056@qq.com （不想保留author可删除）
 * @description m到n的随机数
 * @param m
 * @param n
 * @returns {number}
 */
export function random(m, n) {
  return Math.floor(Math.random() * (m - n) + n)
}

/**
 * @author chuzhixin 1204505056@qq.com （不想保留author可删除）
 * @description addEventListener
 * @type {function(...[*]=)}
 */
export const on = (function () {
  return function (element, event, handler, useCapture = false) {
    if (element && event && handler) {
      element.addEventListener(event, handler, useCapture)
    }
  }
})()

/**
 * @author chuzhixin 1204505056@qq.com （不想保留author可删除）
 * @description removeEventListener
 * @type {function(...[*]=)}
 */
export const off = (function () {
  return function (element, event, handler, useCapture = false) {
    if (element && event) {
      element.removeEventListener(event, handler, useCapture)
    }
  }
})()
