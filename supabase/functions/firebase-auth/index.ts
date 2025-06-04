// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment


// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts"
// supabase/functions/firebase-auth/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://cdn.skypack.dev/@supabase/supabase-js@2'
import { initializeApp, cert } from "npm:firebase-admin@11.8.0/app"
import { getAuth } from "npm:firebase-admin@11.8.0/auth"

// Initialize Firebase Admin 
const serviceAccount = {
  type: "service_account",
  project_id: Deno.env.get('tinytracks-349ae'),
  private_key_id: Deno.env.get('4acc284a7207dc259faa6cafe2d286ceb9fb6f87'),
  private_key: Deno.env.get('-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDmuaY08Yv7KJ0C\nGl83Hu9Hskaa45LyHNz0mKV9ryQQaiiHcfDFB79UUdryeQ7k6PozPp9v4/z9q1/s\nU7wAJOsBmWP/lWzDZ+caS/LOoQ0+bqtZyTvvvhfJgKA3WAhQwa7GZIGuvZncEh/r\nHhgtcKa0ijKchFo1CiTfyeIvbb5ig1NF/GXoONUSkwmpdKVnP0TpP6UJPZhtjKt4\n1Upt/lsDV/7bOoHmZ913zMcSg2oHs3hnHrwV5kAfSGNoIRcS1JVJb3Dsg9pbS0xt\nQCR/6BJhYYutq6FG6KpPPZ97AFGp54rVKIfP26jDrxJbNF3r2bfh4C+DcOdDmMAz\nqCzTGLprAgMBAAECggEAFDF1DlbXqVndcqor4YSibOl5oXkVICiONBV0t80k1bpH\nesyU8IGkPrUn+acbunAjjxRGMFeetErpSyNBpdeVU99WGlqRxCvAqmixmGENv4RA\nbfbH+UxvWNzvk3hvyIrzCNJna+Dp6ZIShhRCXx5oELlfAvDYfkzkJkv32656BmAN\nH+fDMr7mBNWdgqjW5l3yakjQBCNRP+THFjgo9HGmexC4T3A9H72sAE5y8SzguxOb\nWE47Y0YQImlwXC5VzP44zckYslm1a3hHNXbejOxEGT/JmDyhulCkYzNWs6EmttGl\nDJe0BD4iJTdOtoCdW8BYzARK71HF6I/MrdyJeItZgQKBgQD+uC2+KbjGNGrCzfQR\nP5wL7WolVHR6Qc9/n7ZgeM1ZBz+EMsZCM2w6Rac2lUunY/UVyB2NVMhpi0lOcz+q\n1RVZzN5zDf4KUlfHQudZUn3aN3r+rhrnpOfheASxlN3nAz3ukMPnAh5fwNS/ffgf\nmqfAoSe2jPpc6AGNR7l4T7Dl6wKBgQDn4pcXcxF+WO7jKQbbpUZ1OACR5VR8QKPn\nNk7kg/iTBzUX9nulwB0hVV7taCMqvr7lAlQ7zStX6DLCu3AzUE4qwb4V2owZ4KmM\nzxYe5LfTVSGoVYnHbw/Q/jaEH41gQrdVRvw+nciLeXazkx/olAWhKCtN+je7xb7K\nlnubgivdgQKBgQDfMOEb/JDkU6+sjCwtJPCF3v0gQpVhPuMjb/2tIIzGUryMCLWB\n8m8FzFyNTlohDUwGTvfeDAkjuiF8tS13cgioTAQrCnqr7qTte6kdslOGbxC9si7v\nBKcOAE0UkV2y+zs8G+scMtYMjvmb5TQR9UDCYDNdGMCTwdMCSXOxgRp/CwKBgEzr\n0Ysp1KfBAJ3CQlAiZ1kDFs1O8dO17akJTupnDNJZFbe5QBMfw4oHM9I1NVU8qT52\no1KjILmsgQov+2xKO2PbmR7OvKLo79WR7Jia7o/gMaYRmf7aTLjbW2JAxTklaIOV\nZJ+w35HE3Sd8qp0QXT20gYkAc/SKCFxTxvUzHTIBAoGAOLSoGJdsCxWi5MtY+n+4\n5tC8DAqg8RPa1Tp/NL3qqADqOpKTCVo8nU/uYacVxWNIk4sT4sZEudv+JW0QJdtp\nne5y1EuaAHGBmeXQp6KdKgMFIPv+litDQ6515MEnhyHf6gbs89XfwVcbcptKqovR\nmV1fJtTgzePGkt2BNgdIWUw=\n-----END PRIVATE KEY-----\n')?.replace(/\\n/g, '\n'),
  client_email: Deno.env.get('firebase-adminsdk-fbsvc@tinytracks-349ae.iam.gserviceaccount.com'),
  client_id: Deno.env.get('115230637463504970908'),
  auth_uri: "https://accounts.google.com/o/oauth2/auth",
  token_uri: "https://oauth2.googleapis.com/token",
  auth_provider_x509_cert_url: "https://www.googleapis.com/oauth2/v1/certs"
}

// Initialize Firebase Admin
let firebaseApp;
try {
  firebaseApp = initializeApp({
    credential: cert(serviceAccount as any)
  }, 'firebase-auth-function');
} catch (error) {
  console.error('Firebase initialization error:', error);
}

// Initialize Supabase client
const supabaseUrl = Deno.env.get('https://dftiyeepcxznjxikbpbl.supabase.co')!
const supabaseServiceKey = Deno.env.get('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRmdGl5ZWVwY3h6bmp4aWticGJsIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0ODA1MTEwMCwiZXhwIjoyMDYzNjI3MTAwfQ.eUOQbj3duesK5VUUMx9cDflPFZgJw90DWGKlpIaqIXM')!
const supabase = createClient(supabaseUrl, supabaseServiceKey)

interface AuthRequest {
  firebaseToken: string
  action: 'login' | 'register' | 'refresh'
  userData?: {
    child_name?: string
    birth_date?: string
    gender?: string
    email?: string
  }
}

interface AuthResponse {
  success: boolean
  supabaseToken?: string
  user?: any
  error?: string
}

serve(async (req: Request): Promise<Response> => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response(null, {
      status: 200,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Access-Control-Max-Age': '86400',
      },
    })
  }

  // Only allow POST requests
  if (req.method !== 'POST') {
    return new Response(
      JSON.stringify({ success: false, error: 'Method not allowed' }),
      { 
        status: 405,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        }
      }
    )
  }

  try {
    const { firebaseToken, action, userData }: AuthRequest = await req.json()

    if (!firebaseToken) {
      return new Response(
        JSON.stringify({ success: false, error: 'Firebase token is required' }),
        { 
          status: 400,
          headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
          }
        }
      )
    }

    // Verify Firebase token
    const firebaseAuth = getAuth(firebaseApp)
    let decodedToken
    
    try {
      decodedToken = await firebaseAuth.verifyIdToken(firebaseToken)
    } catch (error) {
      console.error('Firebase token verification failed:', error)
      return new Response(
        JSON.stringify({ success: false, error: 'Invalid Firebase token' }),
        { 
          status: 401,
          headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
          }
        }
      )
    }

    const firebaseUid = decodedToken.uid
    const email = decodedToken.email

    // Create custom JWT for Supabase with Firebase UID
    const supabaseJWT = await createSupabaseJWT(firebaseUid, email)

    let response: AuthResponse = { success: true, supabaseToken: supabaseJWT }

    // Handle different actions
    switch (action) {
      case 'register':
        // Create user profile in Supabase
        const { data: newUser, error: insertError } = await supabase
          .from('users_profile')
          .insert({
            uid: firebaseUid,
            email: email,
            child_name: userData?.child_name,
            birth_date: userData?.birth_date,
            gender: userData?.gender,
            height: userData?.height,
            weight: userData?.weight,
            head_circumference: userData?.head_circumference,
            genotype: userData?.genotype,
            blood_group: userData?.blood_group,

            firebase_created_at: new Date(decodedToken.auth_time * 1000).toISOString()
          })
          .select()
          .single()

        if (insertError) {
          console.error('User creation error:', insertError)
          return new Response(
            JSON.stringify({ success: false, error: 'Failed to create user profile' }),
            { 
              status: 500,
              headers: {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
              }
            }
          )
        }

        response.user = newUser
        break

      case 'login':
        // Fetch existing user profile
        const { data: existingUser, error: fetchError } = await supabase
          .from('users_profile')
          .select('*')
          .eq('uid', firebaseUid)
          .single()

        if (fetchError && fetchError.code !== 'PGRST116') {
          console.error('User fetch error:', fetchError)
          return new Response(
            JSON.stringify({ success: false, error: 'Failed to fetch user profile' }),
            { 
              status: 500,
              headers: {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
              }
            }
          )
        }

        response.user = existingUser
        break

      case 'refresh':
        // return of the TOKEN
        break

      default:
        return new Response(
          JSON.stringify({ success: false, error: 'Invalid action' }),
          { 
            status: 400,
            headers: {
              'Content-Type': 'application/json',
              'Access-Control-Allow-Origin': '*',
            }
          }
        )
    }

    return new Response(
      JSON.stringify(response),
      { 
        status: 200,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        }
      }
    )

  } catch (error) {
    console.error('Edge function error:', error)
    return new Response(
      JSON.stringify({ success: false, error: 'Internal server error' }),
      { 
        status: 500,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        }
      }
    )
  }
})

// Helper function to create Supabase JWT
async function createSupabaseJWT(firebaseUid: string, email: string): Promise<string> {
  const header = {
    alg: 'HS256',
    typ: 'JWT'
  }

  const now = Math.floor(Date.now() / 1000)
  const payload = {
    aud: 'authenticated',
    exp: now + 86400, // a day yeah
    iat: now,
    iss: 'supabase',
    sub: firebaseUid, // Use Firebase UID as subject
    firebase_uid: firebaseUid, // Custom claim for our RLS policies
    email: email,
    role: 'authenticated'
  }

  const jwt = await createJWT(header, payload, Deno.env.get('SUPABASE_JWT_SECRET')!)
  return jwt
}

// JWT creation helper
async function createJWT(header: any, payload: any, secret: string): Promise<string> {
  const encoder = new TextEncoder()
  
  const headerB64 = btoa(JSON.stringify(header)).replace(/[+/=]/g, (m) => ({'+': '-', '/': '_', '=': ''}[m] || m))
  const payloadB64 = btoa(JSON.stringify(payload)).replace(/[+/=]/g, (m) => ({'+': '-', '/': '_', '=': ''}[m] || m))
  
  const data = encoder.encode(`${headerB64}.${payloadB64}`)
  const key = await crypto.subtle.importKey(
    'raw',
    encoder.encode(secret),
    { name: 'HMAC', hash: 'SHA-256' },
    false,
    ['sign']
  )
  
  const signature = await crypto.subtle.sign('HMAC', key, data)
  const signatureB64 = btoa(String.fromCharCode(...new Uint8Array(signature)))
    .replace(/[+/=]/g, (m) => ({'+': '-', '/': '_', '=': ''}[m] || m))
  
  return `${headerB64}.${payloadB64}.${signatureB64}`
}