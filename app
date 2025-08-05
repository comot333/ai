'use client';

import { useState } from 'react';
import { Textarea } from '@/components/ui/textarea';
import { Button } from '@/components/ui/button';
import { Card, CardContent } from '@/components/ui/card';

export default function Home() {
  const [input, setInput] = useState('');
  const [chat, setChat] = useState<{ role: string; text: string }[]>([]);
  const [loading, setLoading] = useState(false);

  async function sendMessage() {
    if (!input.trim()) return;
    setLoading(true);

    const userMessage = { role: 'user', text: input };
    setChat((prev) => [...prev, userMessage]);

    const res = await fetch('/api/gemini', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ message: input })
    });

    const data = await res.json();
    const aiMessage = { role: 'gemini', text: data.reply };

    setChat((prev) => [...prev, aiMessage]);
    setInput('');
    setLoading(false);
  }

  return (
    <div className="max-w-xl mx-auto p-4 space-y-4">
      <h1 className="text-2xl font-bold text-center">🤖 Gemini Chatbot</h1>

      <div className="space-y-2 max-h-[70vh] overflow-y-auto">
        {chat.map((msg, i) => (
          <Card key={i} className={msg.role === 'user' ? 'bg-gray-100' : 'bg-blue-100'}>
            <CardContent className="p-3">
              <p><strong>{msg.role === 'user' ? 'You' : 'Gemini'}:</strong> {msg.text}</p>
            </CardContent>
          </Card>
        ))}
      </div>

      <Textarea
        placeholder="Tanyakan sesuatu..."
        value={input}
        onChange={(e) => setInput(e.target.value)}
        className="min-h-[100px]"
      />

      <Button onClick={sendMessage} disabled={loading}>
        {loading ? 'Loading...' : 'Kirim'}
      </Button>
    </div>
  );
}
