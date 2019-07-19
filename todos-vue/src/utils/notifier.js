import { Notification } from 'element-ui'

export const successNotifier = (title, message) => {
  Notification({
    type: 'success',
    title: title,
    message: message
  })
}

export const errorNotifier = (error, title) => {
  Notification({
    type: 'error',
    title: title,
    message: error.response && error.response.data && error.response.data.error
  })
}
