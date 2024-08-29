import request from '@/utils/request'

export function getList(data) {
  return request({
    url: '/factoryManagement/getList',
    method: 'post',
    data,
  })
}

export function doEdit(data) {
  return request({
    url: '/factoryManagement/doEdit',
    method: 'post',
    data,
  })
}

export function doDelete(data) {
  return request({
    url: '/factoryManagement/doDelete',
    method: 'post',
    data,
  })
}
