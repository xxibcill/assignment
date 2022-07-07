import React from 'react'
import { useUserGenerator } from './logic'
import moment from 'moment';

export const UserGenerator: React.FC = () => {
  const { generate, userinfo } = useUserGenerator()

  return (
    <>
      <button style={{ fontSize: 24, marginBottom: 40 }} onClick={generate}>
        Generate
      </button>
      <div>{userinfo && <textarea rows={10} value={JSON.stringify(userinfo, null, '\t')} />}</div>
      <pre>{}</pre>
    </>
  )
}
