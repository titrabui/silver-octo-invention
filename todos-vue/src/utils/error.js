import { Notification } from 'element-ui'

export const errorNotifier = (error, title) => {
  Notification({
    type: 'error',
    title: title,
    message: error.response && error.response.data && error.response.data.error
  })
}
