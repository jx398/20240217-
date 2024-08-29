import request from '@/utils/request'

export function getList(data) {
  return request({
    url: '/taskManagement/getList',
    method: 'post',
    data,
  })
}

export function doEdit(data) {
  return request({
    url: '/taskManagement/doEdit',
    method: 'post',
    data,
  })
}

export function doDelete(data) {
  return request({
    url: '/taskManagement/doDelete',
    method: 'post',
    data,
  })
}
