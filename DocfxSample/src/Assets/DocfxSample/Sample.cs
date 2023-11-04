using UnityEngine;

namespace DocfxSample
{
    /// <summary>
    /// Sample Class.
    /// </summary>
    public class Sample : MonoBehaviour
    {
        /// <summary>
        /// Sample Method.
        /// </summary>
        /// <param name="parameter1">parameter1.</param>
        /// <param name="parameter2">parameter2.</param>
        /// <returns>sum of parameter1 and parameter2.</returns>
        public int Method(int parameter1, int parameter2)
        {
            return parameter1 + parameter2;
        }
    }
}
