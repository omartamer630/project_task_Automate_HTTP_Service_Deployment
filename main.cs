using System;
using System.Net;
using System.Net.Http;


class Program
{
    public static void Main(string[] args)
    {
        Console.WriteLine("httplistener");
        String[] s3_facts = new String[] {
              "Scale storage resources to meet fluctuating needs with 99.999999999% (11 9s) of data durability.",
        "Store data across Amazon S3 storage classes to reduce costs without upfront investment or hardware refresh cycles.",
        "Protect your data with unmatched security, compliance, and audit capabilities.",
        "Easily manage data at any scale with robust access controls, flexible replication tools, and organization-wide visibility.",
        "Run big data analytics, artificial intelligence (AI), machine learning (ML), and high performance computing (HPC) applications.",
        "Meet Recovery Time Objectives (RTO), Recovery Point Objectives (RPO), and compliance requirements with S3’s robust replication features."
        };

        var listener = new HttpListener();
        listener.Prefixes.Add(string.Format("http://*:8002/"));
        listener.Start();

        try
        {
            while (true)
            {
                HttpListenerContext ctx = listener.GetContext();
                using HttpListenerResponse response = ctx.Response;

                response.StatusCode = (int)HttpStatusCode.OK;
                response.StatusDescription = "Status OK";

                Random rnd = new Random();
                int i = rnd.Next(0, s3_facts.Length - 1);

                Console.WriteLine(i);
                Console.WriteLine(s3_facts[i]);

                byte[] buffer = System.Text.Encoding.UTF8.GetBytes( DateTime.Now.TimeOfDay + " - " + s3_facts[i] );
                response.ContentLength64 = buffer.Length;
                response.OutputStream.Write(buffer, 0, buffer.Length);
                response.OutputStream.Close();

            }
        }
        catch (Exception exc)
        {
            Console.WriteLine(exc.ToString());
        }
        finally
        {
            listener.Close();
        }

    }
}
