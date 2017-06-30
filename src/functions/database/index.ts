import * as Umzug from 'umzug'

import { getDatabase } from '../../database'

const getMigrationsPath = () => {
  if (process.env.NODE_ENV === 'production') {
    return './dist/migrations'
  }

  return './build/database/migrations'
}

export const migrate = (event, context, callback) => {
  console.log('MIGRATION STARTED XXX19')

  getDatabase().then((database) => {
    const umzug = new Umzug({
      storage: 'sequelize',
      storageOptions: {
        sequelize: database
      },
      migrations: {
        params: [
          database.getQueryInterface(),
          database.constructor
        ],
        path: getMigrationsPath(),
        pattern: /\.js$/
      }
    })

    return umzug.up()
      .then(() => callback(null))
  })
  .catch(err => console.log(err))
}
