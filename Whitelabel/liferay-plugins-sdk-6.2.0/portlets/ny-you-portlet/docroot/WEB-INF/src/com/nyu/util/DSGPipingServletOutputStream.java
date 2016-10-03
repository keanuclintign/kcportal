package com.nyu.util;


import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.ServletOutputStream;

public class DSGPipingServletOutputStream extends ServletOutputStream {

	public DSGPipingServletOutputStream(OutputStream outputStream) {
		_outputStream = outputStream;
	}

	@Override
	public void close() throws IOException {
		super.close();

		_closed = true;
	}

	public boolean isClosed() {
		return _closed;
	}

	@Override
	public void write(byte[] bytes) throws IOException {
		_outputStream.write(bytes);
	}

	@Override
	public void write(byte[] bytes, int offset, int length)
		throws IOException {

		_outputStream.write(bytes, offset, length);
	}

	@Override
	public void write(int b) throws IOException {
		_outputStream.write(b);
	}

	private boolean _closed;
	private OutputStream _outputStream;

}
