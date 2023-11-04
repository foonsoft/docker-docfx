using System;

namespace DocfxSample
{
    /// <summary>
    /// 基底クラス。
    /// </summary>
    public class BaseClass
    {
        /// <summary>
        /// 基底クラスのメンバ。
        /// </summary>
        public int sum;

        /// <summary>
        /// 基底クラスの仮想メソッド。
        /// sumを+1して返す。
        /// </summary>
        /// <returns>sumの値</returns>
        public virtual int func()
        {
            sum++;
            return sum;
        }
    }

    /// <summary>
    /// 継承クラス。
    /// </summary>
    public class DerivedClass : BaseClass
    {
        /// <summary>
        /// 仮想メソッド。
        /// 基底クラスと異なりsumを+2して返す。
        /// </summary>
        /// <returns>sumの値(derived)</returns>
        public override int func()
        {
            sum++;
            sum++;
            return sum;
        }
    }

    /// <summary>
    /// enumのテスト。
    /// </summary>
    public enum EnumTest
    {
        /// <summary>
        /// 要素1。
        /// </summary>
        Elem1,
        /// <summary>
        /// 要素2。
        /// </summary>
        Elem2,
        /// <summary>
        /// 要素3。
        /// </summary>
        Elem3,
    }
    /// <summary>
    /// enumの拡張メソッドテスト。
    /// </summary>
    public static class EnumTestExt
    {
        /// <summary>
        /// EnumTest.Nameの拡張メソッド。
        /// </summary>
        /// <param name="value">EnumTest。</param>
        /// <returns>EnumTestの値に応じた文字列。</returns>
        public static string Name(this EnumTest value)
        {
            switch (value)
            {
                case EnumTest.Elem1: return "要素1。";
                case EnumTest.Elem2: return "要素2。";
                case EnumTest.Elem3: return "要素3。";
            }
            return "不明。";
        }
    }

    /// <summary>
    /// 実行クラス。
    /// </summary>
    public class Program
    {
        /// <summary>
        /// エントリーポイント
        /// </summary>
        /// <param name="args">引数</param>
        static void Main(string[] args)
        {
            BaseClass b = new BaseClass();
            DerivedClass d = new DerivedClass();
            EnumTest e = EnumTest.Elem1;

            Console.WriteLine("開始。");
            Console.WriteLine("BaseClass     = {0}", b.func());
            Console.WriteLine("DerivedClass  = {0}", d.func());
            Console.WriteLine("EnumTest.Name = {0}", e.Name());
            Console.WriteLine("終了。");
        }
    }
}
