import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { agent = 'Agent_Primary', query } = await req.json()
    
    const supabaseUrl = Deno.env.get('SUPABASE_URL')
    const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')
    
    const supabaseClient = createClient(supabaseUrl, supabaseKey)

    // Simple query first
    const { data, error } = await supabaseClient
      .from('learnings')
      .select('*')
      .limit(5)

    if (error) {
      return new Response(
        JSON.stringify({ 
          error: error.message,
          code: error.code,
          details: error.details,
          hint: error.hint
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 200  // Return 200 so we can see the actual error
        }
      )
    }

    return new Response(
      JSON.stringify({
        success: true,
        agent,
        count: data?.length || 0,
        memories: data || [],
        timestamp: new Date().toISOString()
      }),
      { 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200 
      }
    )

  } catch (error) {
    return new Response(
      JSON.stringify({ 
        caught_error: error.message,
        stack: error.stack 
      }),
      { 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200  // Return 200 to see error details
      }
    )
  }
})
