import Image from 'next/image';
import Twin from '@/components/twin';

export default function Home() {
  return (
    <main className="min-h-screen bg-gradient-to-br from-slate-50 to-gray-100">
      <div className="container mx-auto px-4 py-8">
        <div className="max-w-4xl mx-auto">
          <div className="flex justify-center mb-4">
            <div className="relative w-36 h-36 rounded-full overflow-hidden bg-gray-200">
              <Image
                src="/profile.png"
                alt="Yuan Tian"
                fill
                className="object-cover"
                sizes="144px"
                priority
                unoptimized
              />
            </div>
          </div>
          <h1 className="text-4xl font-bold text-center text-gray-800 mb-2">
            Yuan Tian
          </h1>
          <p className="text-center text-gray-600 mb-8">
            CS PhD candidate @ University of Houston
          </p>

          <div className="h-[600px]">
            <Twin />
          </div>
        </div>
      </div>
    </main>
  );
}