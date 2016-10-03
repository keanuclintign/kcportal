<div class="form-group">
	<%if((Boolean)request.getAttribute("isEnable")){%>
		<input type="checkbox" name="emailDigest" id="emailDigestCheckBox" checked="checked"/> Enable Email Digest
	<%}else{%>
		<input type="checkbox" name="emailDigest" id="emailDigestCheckBox" /> Enable Email Digest
	<%}%>
</div>